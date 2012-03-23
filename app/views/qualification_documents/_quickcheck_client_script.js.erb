// manages individual error items within a collection
function ErrorItem(row){
  this.$row = row;
  var warnings_element = this.$row.children('.count');
  var warnings_count = parseInt(warnings_element.text(), 10);
  this.get_warnings_count = function(){ return warnings_count; };
  this.object_id = this.$row.data('object_id');
  this.increment_warnings = function(){ var newcount = warnings_count + 1; warnings_element.text(newcount); return newcount;};
  this.object_key = 'qualification_documents['+ this.object_id +']';
}

// manages the collection of errors
function Errors(){
  var current_index = 0;
  this.get_current_index = function(){ return current_index ;};
  this.set_current_index = function(new_value){ current_index = new_value ;};
  var list = $('.with_errors');
  this.get_list = function(){ return list; };
  this.get_count = function(){ return list.length; };
  this.at_index = function(i){ return list.eq(i); };
  this.highlight_index = function(i){ list.css('background-color',''); this.at_index(i).css('background-color', '#cc4444'); };
  this.current = function(){ return this.at_index(this.get_current_index()); };
  this.increment_current_index = function(){ this.set_current_index(this.get_current_index() + 1); };
  this.last = function(){ return this.get_count() == this.get_current_index() ;};
  this.message_at_index = function(i){ return this.at_index(i).data('qualification_error_message');};
  this.upload_text_for_index = function(i){ return "Upload new " + this.at_index(i).data('upload_link_text') + " document...";};
}

var errors = new Errors();

/* the QuickcheckForm object builds a form with updated warnings counts
   to be sent to the server when quickcheck is complete */
var QuickcheckForm = {
  config: { form: 'form#quickcheck_complete' },
  add_input: function(){
    QuickcheckForm.create_input();
    $(QuickcheckForm.config.form).append(QuickcheckForm.input);
  },
  create_input: function(){
    QuickcheckForm.row = new ErrorItem(errors.current());
    QuickcheckForm.input = document.createElement('input');
    $(QuickcheckForm.input).attr({ type: 'hidden',
                                   name: QuickcheckForm.row.object_key+'[warnings]',
                                   value:  QuickcheckForm.row.increment_warnings() });
  }
}

/* The form for uploading qualification documents */
var DocumentForm = {
  config: { form: 'form#docform',
            input: '#docfile_input' },
  add_input: function(){
    DocumentForm.create_input();
    $(DocumentForm.config.form).append(DocumentForm.input);
  },
  create_input: function(){
    DocumentForm.row = new ErrorItem(errors.current());
    DocumentForm.input = document.createElement('input');
    $(DocumentForm.input).attr({ type: 'hidden',
                                 name: DocumentForm.row.object_key+'[warnings]',
                                 value:  DocumentForm.row.get_warnings_count() });
  },
  select_docfile: function(){
    DocumentForm.row = new ErrorItem(errors.current());
    $(DocumentForm.config.input).attr('name','qualification_documents['+DocumentForm.row.object_id+'][docfile]');
  }
}

/* increments the warnings count for a particular error
   and highlight the next. When there are no more, the 
   Quickcheck complete button is shown. */
var increment_warnings_for_next = function(){
  if(!errors.last()){
    QuickcheckForm.add_input(); // warnings count is incremented by QuickcheckForm
    DocumentForm.add_input();
    DocumentForm.select_docfile();
    errors.increment_current_index(); // note: this may change the value of errors.last
    ask_about(errors.get_current_index());
  }

  if(errors.last()){ 
  /* when all errors have been highlighted:
             hide the last error
             hide the action links
             show the 'quickcheck complete' button
  */
    $('#error_message').css('display', 'none');
    $('#action_links a').css('display', 'none');
    $('#action_links input[type=submit]').css('display','block'); }
};


/* for each of the errors that the server has flagged,
   the user is asked whether to update the documentation now
   or to warn the client now, increment the warnings, and waive
   the requirement for this visit */
var ask_about = function(index){
  errors.highlight_index(index);
  // pull the error message directly from the row displaying the data.
  $('#error_message').html(errors.message_at_index(index)); 
  $('#upload').html(errors.upload_text_for_index(index));
  DocumentForm.select_docfile();
};

ask_about(errors.get_current_index());
