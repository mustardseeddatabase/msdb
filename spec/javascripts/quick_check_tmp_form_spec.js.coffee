describe "initialize form", ->
  afterEach ->
    $('form#tempForm').remove()

  it "should render a form element", ->
    new Quickcheck.TmpFormView
    expect($('form#tempForm').length).toEqual(1)

  it "should configure the form's url and method", ->
    new Quickcheck.TmpFormView(action:"/foo/bar/baz", method:'post')
    expect($('form#tempForm').attr('action')).toEqual("/foo/bar/baz")
    expect($('form#tempForm').attr('method')).toEqual("post")

  it "should append form elements", ->
    new Quickcheck.TmpFormView({action:"/foo/bar/baz"},{authenticity_token: "an_arbitrary_string"})
    expect($('input','form#tempForm').first().attr('name')).toEqual('authenticity_token')
    expect($('input','form#tempForm').first().attr('value')).toEqual('an_arbitrary_string')

  it "should append multiple form elements", ->
    new Quickcheck.TmpFormView({action:"/foo/bar/baz"},{authenticity_token: "an_arbitrary_string", "qualification_document[id]":55})
    expect($('input','form#tempForm').last().attr('name')).toEqual('qualification_document[id]')
    expect($('input','form#tempForm').last().attr('value')).toEqual('55')

# unable to get sinon server to intercept xhr
#describe "submit form", ->
  #beforeEach ->
    #@server = sinon.fakeServer.create()
    #@server.autoRespond = true

  #afterEach ->
    #@server.restore()

  #it "should submit the form", ->
    #form = new Quickcheck.TmpFormView({action:"/foo/bar/baz"},{authenticity_token: "an_arbitrary_string", "qualification_document[id]":55})
    #@server.respond()
    #form.submit()
    #expect(@server.requests.length).toEqual(1)
