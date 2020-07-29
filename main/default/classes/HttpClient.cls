public class HttpClient {

    private HttpRequest request;
    private List<HttpInterceptor.Request> requestInterceptors;
    private List<HttpInterceptor.Response> responseInterceptors;

    public HttpClient(List<HttpInterceptor.Request> requestInterceptors, List<HttpInterceptor.Response> responseInterceptors) {

        this.request = new HttpRequest();
        this.requestInterceptors = requestInterceptors;
        this.responseInterceptors = responseInterceptors;
    }

    public HttpClient addHeader(String key, String value){
        this.request.setHeader(key, value);
        return this;
    }

    private HttpClient setMethod(String method){
        this.request.setMethod(method);
        return this;
    }

    private HttpClient setEndpoint(String endpoint){
        this.request.setEndpoint(endpoint);
        return this;
    }

    public HttpClient json(Object obj){
        this.request.setBody(JSON.serialize(obj));
        this.request.setHeader('Content-Type', 'application/json');
        return this;
    }
    
    public HttpClient json(String body){
        this.request.setBody(body);
        this.request.setHeader('Content-Type', 'application/json');
        return this;
    }

    public HttpResponse post(String endpoint){
        return setMethod('POST').setEndpoint(endpoint).send();
    }

    public HttpResponse get(String endpoint){
        return setMethod('GET').setEndpoint(endpoint).send();
    }

    private HttpResponse send(){
        
        for(HttpInterceptor.Request interceptor : requestInterceptors){

            interceptor.interceptRequest(this.request);
        }

        HttpResponse response = new Http().send(request);

        for(HttpInterceptor.Response interceptor: responseInterceptors){

            interceptor.interceptResponse(request, response);
        }

        return response;

    }

    public class Builder {

        private List<HttpInterceptor.Request> requestInterceptors;
        private List<HttpInterceptor.Response> responseInterceptors;

        public Builder(){
            requestInterceptors = new List<HttpInterceptor.Request>();
            responseInterceptors = new List<HttpInterceptor.Response>();
        }
        
        public Builder addRequestInterceptor(HttpInterceptor.Request interceptor){
            this.requestInterceptors.add(interceptor);
            return this;
        }

        public Builder addResponseInterceptor(HttpInterceptor.Response interceptor){
            this.responseInterceptors.add(interceptor);
            return this;
        }

        public HttpClient build(){
            return new HttpClient(this.requestInterceptors, this.responseInterceptors);
        }

    }

}