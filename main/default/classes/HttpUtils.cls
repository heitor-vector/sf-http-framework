public with sharing class HttpUtils {
    
    public static Boolean isSuccessful(HttpResponse response){
        return response.getStatusCode() >= 200 && response.getStatusCode() < 300;
    }
}
