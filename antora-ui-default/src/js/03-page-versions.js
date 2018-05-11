;(function () {
  'use strict'

  var toggle = document.querySelector('.page-versions .versions-menu-toggle')
  if (!toggle) return

  var selector = document.querySelector('.page-versions')

  toggle.addEventListener('click', function (e) {
    selector.classList.toggle('is-active')
    // don't let this event get smothered
    e.stopPropagation()
  })

  window.addEventListener('click', function () {
    selector.classList.remove('is-active')
  })
})()
