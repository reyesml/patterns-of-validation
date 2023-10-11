require_relative 'gateway'

RSpec.describe Gateway do
  let(:gateway) { Gateway.new }

  tests = [
    { method: :read, args: { id: 7 }, expect: "authorized\nvalid\nread 7\nAfter!\n" },
    { method: :read, args: { id: 'foo' }, expect: "authorized\ninvalid\nread foo\nAfter!\n" },
    { method: :write, args: { id: 7, body: 'hello' }, expect: "authorized\nvalid\nwrite 7: hello\nAfter!\n" },
    { method: :write, args: { id: 'foo', body: 'hello' }, expect: "authorized\ninvalid\nwrite foo: hello\nAfter!\n" },
    { method: :delete, args: { id: 7 }, expect: "authorized\nvalid\ndelete 7\nAfter!\n" },
    { method: :delete, args: { id: 'foo' }, expect: "authorized\ninvalid\ndelete foo\nAfter!\n" },
    { method: :list, expect: "authorized\nlisting all\nAfter!\n" }
  ]

  tests.each do |t|
    describe "Method #{t[:method]}" do
      it "outputs #{t[:expect]}" do
        expect do
          if t[:args].nil?
            gateway.send(t[:method].to_s)
          else
            gateway.send(t[:method].to_s, **t[:args])
          end
        end.to output(t[:expect]).to_stdout
      end
    end
  end
end
