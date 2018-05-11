;(function () {
  'use strict'

  var navContainer = document.querySelector('.navigation-container')
  var navToggle = document.querySelector('.navigation-toggle')

  navToggle.addEventListener('click', toggleNavigation)
  // don't let click events propagate outside of navigation container
  navContainer.addEventListener('click', concealEvent)

  var menuPanel = navContainer.querySelector('[data-panel=menu]')
  if (!menuPanel) return

  var navState = getNavState()
  var menuState = getMenuState(navState, navContainer.dataset.component, navContainer.dataset.version)

  navContainer.querySelector('.context').addEventListener('click', function () {
    var currentPanel = navContainer.querySelector('.is-active[data-panel]')
    var activatePanel = currentPanel.dataset.panel === 'menu' ? 'explore' : 'menu'
    currentPanel.classList.toggle('is-active')
    navContainer.querySelector('[data-panel=' + activatePanel + ']').classList.toggle('is-active')
  })

  find('.nav-toggle', menuPanel).forEach(function (btn) {
    var li = btn.parentElement
    btn.addEventListener('click', function () {
      li.classList.toggle('is-active')
      menuState.expandedItems = getExpandedItems()
      saveNavState()
    })
  })

  find('.nav-item', menuPanel).forEach(function (item, idx) {
    item.setAttribute('data-id', 'menu-' + item.dataset.depth + '-' + idx)
  })

  var expandedItems = menuState.expandedItems || (menuState.expandedItems = [])

  if (expandedItems.length) {
    find(
      expandedItems
        .map(function (itemId) {
          return '.nav-item[data-id="' + itemId + '"]'
        })
        .join(','),
      menuPanel
    ).forEach(function (item) {
      item.classList.add('is-active')
    })
  }

  var currentPageItem = menuPanel.querySelector('.is-current-page')
  if (currentPageItem) {
    activateCurrentPath(currentPageItem).forEach(function (itemId) {
      if (expandedItems.indexOf(itemId) < 0) expandedItems.push(itemId)
    })
  }

  saveNavState()

  scrollItemIntoView(menuState.scroll || 0, menuPanel, currentPageItem && currentPageItem.querySelector('.nav-link'))

  menuPanel.addEventListener('scroll', function () {
    menuState.scroll = Math.round(menuPanel.scrollTop)
    saveNavState()
  })

  function activateCurrentPath (navItem) {
    var ids = [navItem.dataset.id]
    var ancestorClasses
    var ancestor = navItem.parentNode
    while (!(ancestorClasses = ancestor.classList).contains('nav-menu')) {
      if (ancestor.tagName === 'LI' && ancestorClasses.contains('nav-item')) {
        ancestorClasses.add('is-active', 'is-current-path')
        ids.push(ancestor.dataset.id)
      }
      ancestor = ancestor.parentNode
    }
    navItem.classList.add('is-active')
    return ids
  }

  function toggleNavigation (e) {
    if (navToggle.classList.contains('is-active')) return closeNavigation(e)
    document.documentElement.classList.add('is-clipped--nav')
    navToggle.classList.add('is-active')
    navContainer.classList.add('is-active')
    window.addEventListener('click', closeNavigation)
    // don't let this event get picked up by window click listener
    concealEvent(e)
  }

  function closeNavigation (e) {
    if (e.which === 3 || e.button === 2) return
    document.documentElement.classList.remove('is-clipped--nav')
    navToggle.classList.remove('is-active')
    navContainer.classList.remove('is-active')
    window.removeEventListener('click', closeNavigation)
    // don't let this event get picked up by window click listener
    concealEvent(e)
  }

  function concealEvent (e) {
    e.stopPropagation()
  }

  function getExpandedItems () {
    return find('.is-active', menuPanel).map(function (item) {
      return item.dataset.id
    })
  }

  function getNavState () {
    var data = window.sessionStorage.getItem('nav-state')
    return data && (data = JSON.parse(data)).__version__ === '1' ? data : { __version__: '1' }
  }

  function getMenuState (navState, component, version) {
    var key = version + '@' + component
    return navState[key] || (navState[key] = {})
  }

  function saveNavState () {
    window.sessionStorage.setItem('nav-state', JSON.stringify(navState))
  }

  function scrollItemIntoView (scrollPosition, parent, el) {
    if (!el) return (parent.scrollTop = scrollPosition)

    var margin = 10
    var overTheTop = el.offsetTop - scrollPosition < 0
    var belowTheBottom = el.offsetTop - scrollPosition + el.offsetHeight > parent.offsetHeight

    if (overTheTop) {
      parent.scrollTop = el.offsetTop - margin
    } else if (belowTheBottom) {
      parent.scrollTop = el.offsetTop - (parent.offsetHeight - el.offsetHeight) + margin
    } else {
      parent.scrollTop = scrollPosition
    }
  }

  function find (selector, from) {
    return [].slice.call((from || document).querySelectorAll(selector))
  }
})()
