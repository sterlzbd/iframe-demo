require "roda"

class App < Roda
  START = "/frame/page/10"

  def home
    <<~HOME
      <!DOCTYPE html>
      <html>
        <head>
          <title>Test driver</title>
        </head>
        <body>
          <iframe id="inlineFrameExample"
            title="Inline Frame Example"
            width="300"
            height="200"
            src='#{START}'>
          </iframe>
        </body>
      </html>
    HOME
  end

  def document(page)
    <<~DOC
      <!DOCTYPE html>
      <html>
        <head>
          <title>
            Frame
          </title>
          <script>
            function reloadWith(i) {
              window.location.href = '/frame/page/' + i;
            }
          </script>
        </head>
        <body>
          <button id='prev' onclick="reloadWith(#{page - 1})">-1</button>
          <button id='next' onclick="reloadWith(#{page + 1})">+1</button>
          <p id='valueToRead'>#{page}</p>
        </body>
      </html>
    DOC
  end

  route do |r|
    r.on do
      r.on "frame" do
        r.on "page" do
          r.get Integer do |i|
            document i
          end

          r.get do
            r.redirect START
          end
        end

        r.get do
          home
        end
      end

      r.get do
        r.redirect "/frame"
      end
    end
  end
end
