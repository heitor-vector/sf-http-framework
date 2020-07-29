public class HttpInterceptor {
    
    public interface Request{

        void interceptRequest(HttpRequest request);
    }

    public interface Response{

        void interceptResponse(HttpRequest request, HttpResponse response); 
    }
}