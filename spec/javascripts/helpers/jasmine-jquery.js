var readFixtures = function() {
  return jasmine.getFixtures().proxyCallTo_('read', arguments);
};

var preloadFixtures = function() {
  jasmine.getFixtures().proxyCallTo_('preload', arguments);
};

var loadFixtures = function() {
  jasmine.getFixtures().proxyCallTo_('load', arguments);
};

var setFixtures = function(html) {
  jasmine.getFixtures().set(html);
};

var sandbox = function(attributes) {
  return jasmine.getFixtures().sandbox(attributes);
};

var spyOnEvent = function(selector, eventName) {
  jasmine.JQuery.events.spyOn(selector, eventName);
}

jasmine.getfixtures = function() {
  return jasmine.currentfixtures_ = jasmine.currentfixtures_ || new jasmine.fixtures();
};

jasmine.fixtures = function() {
  this.containerid = 'jasmine-fixtures';
  this.fixturescache_ = {};
  this.fixturespath = 'spec/javascripts/fixtures';
};

jasmine.fixtures.prototype.set = function(html) {
  this.cleanup();
  this.createcontainer_(html);
};

jasmine.fixtures.prototype.preload = function() {
  this.read.apply(this, arguments);
};

jasmine.fixtures.prototype.load = function() {
  this.cleanup();
  this.createcontainer_(this.read.apply(this, arguments));
};

jasmine.fixtures.prototype.read = function() {
  var htmlchunks = [];

  var fixtureurls = arguments;
  for(var urlcount = fixtureurls.length, urlindex = 0; urlindex < urlcount; urlindex++) {
    htmlchunks.push(this.getfixturehtml_(fixtureurls[urlindex]));
  }

  return htmlchunks.join('');
};

jasmine.fixtures.prototype.clearcache = function() {
  this.fixturescache_ = {};
};

jasmine.fixtures.prototype.cleanup = function() {
  jquery('#' + this.containerid).remove();
};

jasmine.fixtures.prototype.sandbox = function(attributes) {
  var attributestoset = attributes || {};
  return jquery('<div id="sandbox" />').attr(attributestoset);
};

jasmine.fixtures.prototype.createcontainer_ = function(html) {
  var container;
  if(html instanceof jquery) {
    container = jquery('<div id="' + this.containerid + '" />');
    container.html(html);
  } else {
    container = '<div id="' + this.containerid + '">' + html + '</div>'
  }
  jquery('body').append(container);
};

jasmine.fixtures.prototype.getfixturehtml_ = function(url) {  
  if (typeof this.fixturescache_[url] == 'undefined') {
    this.loadfixtureintocache_(url);
  }
  return this.fixturescache_[url];
};

jasmine.fixtures.prototype.loadfixtureintocache_ = function(relativeurl) {
  var self = this;
  var url = this.fixturespath.match('/$') ? this.fixturespath + relativeurl : this.fixturespath + '/' + relativeurl;
  jquery.ajax({
    async: false, // must be synchronous to guarantee that no tests are run before fixture is loaded
    cache: false,
    datatype: 'html',
    url: url,
    success: function(data) {
      self.fixturescache_[relativeurl] = data;
    },
    error: function(jqxhr, status, errorthrown) {
        throw error('fixture could not be loaded: ' + url + ' (status: ' + status + ', message: ' + errorthrown.message + ')');
    }
  });
};

jasmine.fixtures.prototype.proxycallto_ = function(methodname, passedarguments) {
  return this[methodname].apply(this, passedarguments);
};


jasmine.JQuery = function() {};

jasmine.JQuery.browserTagCaseIndependentHtml = function(html) {
  return jQuery('<div/>').append(html).html();
};

jasmine.JQuery.elementToString = function(element) {
  return jQuery('<div />').append(element.clone()).html();
};

jasmine.JQuery.matchersClass = {};

(function(namespace) {
  var data = {
    spiedEvents: {},
    handlers:    []
  };

  namespace.events = {
    spyOn: function(selector, eventName) {
      var handler = function(e) {
        data.spiedEvents[[selector, eventName]] = e;
      };
      jQuery(selector).bind(eventName, handler);
      data.handlers.push(handler);
    },

    wasTriggered: function(selector, eventName) {
      return !!(data.spiedEvents[[selector, eventName]]);
    },

    cleanUp: function() {
      data.spiedEvents = {};
      data.handlers    = [];
    }
  }
})(jasmine.JQuery);

(function(){
  var jQueryMatchers = {
    toHaveClass: function(className) {
      return this.actual.hasClass(className);
    },

    toBeVisible: function() {
      return this.actual.is(':visible');
    },

    toBeHidden: function() {
      return this.actual.is(':hidden');
    },

    toBeSelected: function() {
      return this.actual.is(':selected');
    },

    toBeChecked: function() {
      return this.actual.is(':checked');
    },

    toBeEmpty: function() {
      return this.actual.is(':empty');
    },

    toExist: function() {
      return this.actual.size() > 0;
    },

    toHaveAttr: function(attributeName, expectedAttributeValue) {
      return hasProperty(this.actual.attr(attributeName), expectedAttributeValue);
    },

    toHaveId: function(id) {
      return this.actual.attr('id') == id;
    },

    toHaveHtml: function(html) {
      return this.actual.html() == jasmine.JQuery.browserTagCaseIndependentHtml(html);
    },

    toHaveText: function(text) {
      if (text && jQuery.isFunction(text.test)) {
        return text.test(this.actual.text());
      } else {
        return this.actual.text() == text;
      }
    },

    toHaveValue: function(value) {
      return this.actual.val() == value;
    },

    toHaveData: function(key, expectedValue) {
      return hasProperty(this.actual.data(key), expectedValue);
    },

    toBe: function(selector) {
      return this.actual.is(selector);
    },

    toContain: function(selector) {
      return this.actual.find(selector).size() > 0;
    },

    toBeDisabled: function(selector){
      return this.actual.is(':disabled');
    },

    // tests the existence of a specific event binding
    toHandle: function(eventName) {
      var events = this.actual.data("events");
      return events && events[eventName].length > 0;
    },
    
    // tests the existence of a specific event binding + handler
    toHandleWith: function(eventName, eventHandler) {
      var stack = this.actual.data("events")[eventName];
      var i;
      for (i = 0; i < stack.length; i++) {
        if (stack[i].handler == eventHandler) {
          return true;
        }
      }
      return false;
    }
  };

  var hasProperty = function(actualValue, expectedValue) {
    if (expectedValue === undefined) {
      return actualValue !== undefined;
    }
    return actualValue == expectedValue;
  };

  var bindMatcher = function(methodName) {
    var builtInMatcher = jasmine.Matchers.prototype[methodName];

    jasmine.JQuery.matchersClass[methodName] = function() {
      if (this.actual instanceof jQuery) {
        var result = jQueryMatchers[methodName].apply(this, arguments);
        this.actual = jasmine.JQuery.elementToString(this.actual);
        return result;
      }

      if (builtInMatcher) {
        return builtInMatcher.apply(this, arguments);
      }

      return false;
    };
  };

  for(var methodName in jQueryMatchers) {
    bindMatcher(methodName);
  }
})();

beforeEach(function() {
  this.addMatchers(jasmine.JQuery.matchersClass);
  this.addMatchers({
    toHaveBeenTriggeredOn: function(selector) {
      this.message = function() {
        return [
          "Expected event " + this.actual + " to have been triggered on" + selector,
          "Expected event " + this.actual + " not to have been triggered on" + selector
        ];
      };
      return jasmine.JQuery.events.wasTriggered(selector, this.actual);
    }
  })
});

afterEach(function() {
  jasmine.getFixtures().cleanUp();
  jasmine.JQuery.events.cleanUp();
});

