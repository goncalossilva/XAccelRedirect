# Copyright (c) 2009 Gonçalo Silva <goncalossilva@gmail.com>
# based on the work of John Guenin <john@guen.in>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module XAccelRedirect
  module Controller
    # Sends the file by setting the X-Sendfile HTTP header.  You web server
    # must be configured to respond to this header, or it will not work.
    #
    # Options:
    # * <tt>:filename</tt> - suggests a filename for the browser to use.
    #   Defaults to File.basename(path).
    # * <tt>:type</tt> - specifies an HTTP content type.
    #   Defaults to 'application/octet-stream'.
    # * <tt>:disposition</tt> - specifies whether the file will be shown inline or downloaded.
    #   Valid values are 'inline' and 'attachment' (default).
    # * <tt>:status</tt> - specifies the status code to send with the response. Defaults to '200 OK'.
    # * <tt>:url_based_filename</tt> - set to true if you want the browser guess the filename from
    #   the URL, which is necessary for i18n filenames on certain browsers
    #   (setting :filename overrides this option).
    # * <tt>:header</tt> - specifies the name to use for the X-Sendfile HTTP header
    #   Defaults to 'X-Sendfile'.
    # * <tt>:file_paths</tt> - list of acceptible file paths
    # * <tt>:root</tt> - the root directory is removed when file path specified in header
    #
    # Simple download:
    #   x_accel_redirect '/path/to/file'
    #
    # Show a JPEG in the browser:
    #   x_accel_redirect('/path/to/image.jpg', :type => 'image/jpeg', :disposition => 'inline')
    #
    # x_accel_redirect's options and defaults mirror those of send_file.  Please see
    # ActionController::Streaming#send_file for more detailed information about
    # the options, HTTP specs, and possible security issues.
    def x_accel_redirect(path, options = {})

      raise ActionController::MissingFile, "Cannot read file #{path}" unless File.file?(path) and File.readable?(path)

      # pull in default values for options and delete x_sendfile option if present
      options.reverse_merge!(Plugin.options)
      options.delete(:x_sendfile)

      #raise expeption if path is not include
      if Array(options[:file_paths]).any? && (File.expand_path(path) =~ Regexp.new("^(%s)" % Array(options[:file_paths]).join('|'))).nil?
        raise ActionController::MissingFile, "Invalid file #{path}. Must be in #{Array(options[:file_paths]).join(', ')}"
      end

      options[:length]   ||= File.size(path)
      options[:filename] ||= File.basename(path) unless options[:url_base_filename]

      # set headers & send response
      send_file_headers! options

      #remove the root
      path = File.expand_path(path).gsub(options[:root], '') if options[:root]

      response.headers[options[:header]] = path
      logger.info "Sending XAccelRedirect header for #{path}" unless logger.nil?
      render options[:render]
    end

    alias_method :send_file_with_x_accel_redirect, :x_accel_redirect
  end
end

