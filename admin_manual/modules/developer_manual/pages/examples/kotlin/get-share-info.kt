package main

import okhttp3.Credentials
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.IOException

fun main(args: Array<String>) {
    val ownCloudDomain = "your.owncloud.domain.com/owncloud"
    var client = OkHttpClient()
    val credentials = Credentials.basic("your.username", "your.password");

    var builder = Request.Builder()
            .url("https://$ownCloudDomain/ocs/v1.php/apps/files_sharing/api/v1/shares/<share_id>'")
            .header("Authorization", credentials)
            .build()

    try {
        var response = client.newCall(builder).execute()

        when {
            response.isSuccessful -> println(
                    "Request was successful. Response was: ${response.body()?.string()}"
            )
            else -> println("Request was not successful.")
        }
    } catch (e: IOException) {
        println("Request failed. Reason: ${e.toString()}")
    }
}
