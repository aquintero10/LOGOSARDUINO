var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var movSchema = new Schema({
  _id: {
      type: String,
      required: true
  },
  mov: {
    type: String,
    required: true
  },
  RegisterDate:{
    type:String,
    required:true
  },
  Duration:{
    type:String,
    required:true
  },
  place:{
    type:String,
    required:true
  }

});
var movModel = mongoose.model('mov', movSchema);
module.exports = movModel;