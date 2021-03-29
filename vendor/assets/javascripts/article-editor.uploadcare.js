// Icon
ArticleEditor.iconTags = '<svg height="16" viewBox="0 0 16 16" width="16" xmlns="http://www.w3.org/2000/svg"><path d="m13.454 1c.853089 0 1.546.69366173 1.546 1.546v4.36371429c0 .56592472-.2790572 1.24002756-.6652017 1.62429902l-5.78655018 6.01223499c-.60256278.6050023-1.58507632.6050023-2.18621204.0014299l-4.90828435-4.90828722c-.60500231-.60256278-.60500231-1.58507632.01233983-2.19971875l5.98566032-5.75877764c.39921147-.40082772 1.07325621-.68089459 1.63853383-.68089459zm-.454 2h-3.90971429c-.0333803 0-.19751184.06819697-.23666299.10718491l-5.65962272 5.44381509 4.254 4.254 5.4606089-5.67296241c.0188278-.01875188.0660214-.12740905.0841458-.18802473l.0072453-.03429857zm-2 1c.553 0 1 .447 1 1s-.447 1-1 1-1-.447-1-1 .447-1 1-1z"/></svg>';
// Block
ArticleEditor.add('block', 'block.tags', {
  mixins: ['block'],
  type: 'tags',
  parser: {
    tag: 'div',
    parse: function($el) {
      return ($el.hasClass('tags')) ? 'tags' : false;
    }
  },
  control: {
    trash: { command: 'block.remove', title: '## buttons.delete ##' },
    duplicate: { command: 'block.duplicate', title: '## buttons.duplicate ##'  }
  },
  create: function() {
    return this.dom('<div>').addClass('tags');
  }
});
// Plugin
ArticleEditor.add('plugin', 'uploadcare', {
  translations: {
    en: {
      "blocks": {
        "tags": "Upload"
      }
    }
  },
  defaults: {
    classname: 'tag'
  },
  start: function() {
    $opts = this.opts.uploadcare;
    // defaults
    if (!$opts.crop) {
      $opts.crop = '';
    }
    if (!$opts.version) {
      $opts.version = '2.8.2';
    }
    if (typeof uploadcare === 'undefined') {
      var widget_url = 'https://ucarecdn.com/widget/' + $opts.version + '/uploadcare/uploadcare.min.js';
      $.getScript(widget_url);
    }
    this.app.addbar.add('tags', {
      title: '## blocks.tags ##',
      icon: ArticleEditor.iconTags,
      command: 'uploadcare.popup'
    });
  },
  o_editor: null,
  popup: function() {
    var dialog = uploadcare.openDialog({}, $opts);
    var editor = this.app
    dialog.done(function(data) {
      editor.app.uploadcare.insert(data, editor)
    })
  },
  insert: function(data, editor) {
    var $this = this;
    var files = $opts.multiple ? data.files() : [data];
    $.when.apply(null, files).done(function() {
      $.each(arguments, function() {
        if ($.isFunction($opts.uploadCompleteCallback)) {
          $opts.uploadCompleteCallback.call($this, this);
        } else {
          var imageUrl = this.cdnUrl;
          if (this.isImage && !this.cdnUrlModifiers) {
            imageUrl += '-/preview/';
          }
          var instance = instance || editor.create('block.tags');
          var $block = instance.getBlock();
          if (this.isImage) {
            $block.append('<img src="' + imageUrl + '" alt="' + this.name + '" />');
          } else {
            $block.append('<a href="' + this.cdnUrl + '">' + this.name + '</a>');
          }
          // insert
          if (instance) {
            editor.block.add({ instance: instance });
          }
        }
      });
    });
  }
});