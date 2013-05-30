require 'net/https'

class HttpFetcher
  NET_HTTP_EXCEPTIONS = [
                         EOFError,
                         Errno::ECONNABORTED,
                         Errno::ECONNREFUSED,
                         Errno::ECONNRESET,
                         Errno::ECONNRESET, EOFError,
                         Errno::EINVAL,
                         Errno::ETIMEDOUT,
                         Net::HTTPBadResponse,
                         Net::HTTPClientError,
                         Net::HTTPError,
                         Net::HTTPFatalError,
                         Net::HTTPHeaderSyntaxError,
                         Net::HTTPRetriableError,
                         Net::HTTPServerException,
                         Net::ProtocolError,
                         SocketError,
                         Timeout::Error,
                        ]

  NET_HTTP_EXCEPTIONS << OpenSSL::SSL::SSLError if defined?(OpenSSL)

  attr_accessor :response

  def get(uri, headers = {})
    token_uri = URI.parse(uri)
    http = Net::HTTP.new(token_uri.host, token_uri.port)
    http.use_ssl = token_uri.scheme == 'https'
    req = Net::HTTP::Get.new(token_uri.request_uri)
    req['Authorization'] = headers[:authorization].chomp
    @response = http.request(req)
    return @response.body
  end

  def post(uri, data, options={})
    defaults = { :headers => {} }
    options = options.deep_merge(defaults)
    token_uri = URI.parse(uri)
    http = Net::HTTP.new(token_uri.host, token_uri.port)
    http.use_ssl = token_uri.scheme == 'https'
    http.read_timeout = 600
    req = Net::HTTP::Post.new(token_uri.request_uri)

    options[:headers].each do |key, val|
      req[key] = val
    end

    if options[:basic_auth]
      req.basic_auth(options[:basic_auth][:username], options[:basic_auth][:password])
    end

    #TODO: Remove this hack
    if data.is_a?(Hash)
      req.set_form_data(data)
    else
      req.body = data
    end
    @response = http.request(req)
    @response.body
  end

  def headers
    result = {}
    @response.each_header do |k,v|
      result[k] = v
    end
    result
  end

  def status
    @response.code.to_i
  end

  def success?
    (200..299).include?(status)
  end

  def failure?
    !success?
  end
end