// Execute in mongosh against a disposable database: use mit8103_academic_nosql
use('mit8103_academic_nosql');
db.student_profiles.insertMany([
  {matric_number:'STU00003',name:{first:'Student3',last:'Demo'},program:'MIT',skills:['SQL','Python'],preferences:{notifications:true,theme:'dark'}},
  {matric_number:'STU00006',name:{first:'Student6',last:'Demo'},program:'MIT',skills:['MongoDB','JavaScript'],preferences:{notifications:false,theme:'light'}}
]);
db.student_profiles.createIndex({matric_number:1},{unique:true});
db.student_profiles.find({program:'MIT'});
db.student_profiles.find({'skills':'SQL'});
db.student_profiles.updateOne({matric_number:'STU00003'},{$set:{'preferences.theme':'light'}});
db.student_profiles.aggregate([{$unwind:'$skills'},{$group:{_id:'$skills',students:{$sum:1}}},{$sort:{students:-1}}]);
