import okhttp3.Credentials;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class GetShareInfo {
    OkHttpClient client = new OkHttpClient();

    String run(String url, String credentials) throws IOException {
        Request request = new Request.Builder()
                .url(url)
                .header("Authorization", credentials)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                String responseBody = (response.body().string() != null) ? response.body().string() : "empty";
                return "Request was successful. Response was: " + responseBody;
            }

        } catch (IOException e) {
            return "Request was not successful. Reason: " + e.toString();
        }

        return "Request was not successful.";
    }

    public static void main(String[] args) throws IOException {
        GetShareInfo info = new GetShareInfo();

        String credentials = Credentials.basic("your.username", "your.password");
        String ownCloudDomain = "your.owncloud.domain.com/owncloud";
        String url = "https://" + ownCloudDomain + "/ocs/v1.php/apps/files_sharing/api/v1/shares/<share_id>'";

        String response = info.run(url, credentials);
        System.out.println(response);
    }
}
