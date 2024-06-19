# frozen_string_literal: true

require 'roda'

class App < Roda

  START = '/frame/page/1'
  HOME = <<~HOME.freeze
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
        <a href='/frame'">Start</a>
      </body>
    </html>
  HOME

  def document(page)
    <<~DOC
      <!DOCTYPE html>
      <html>
        <head>
          <title>
            Frame
          </title>
        </head>
        <body>
          <a id='next' href='/frame/page/#{page + 1}'">+1</a>
          <a id='next-slow' href='/frame/page/#{page + 1}?slow'">+1 (slow)</a>
          <a id='restart' href='#{START}'">Restart</a>
          <p id='valueToRead'>#{page}</p>
        </body>
      </html>
    DOC
  end

  route do |r|
    # If the responses are fast enough the issue of not waiting for navigation
    # is less consistently testable.
    sleep 0.2 if r.params.key?('slow')

    r.on do
      r.on 'frame' do
        r.on 'page' do
          r.get Integer do |i|
            document i
          end

          r.get do
            r.redirect START
          end
        end

        r.get do
          HOME
        end
      end

      r.get do
        r.redirect '/frame'
      end
    end
  end
end
