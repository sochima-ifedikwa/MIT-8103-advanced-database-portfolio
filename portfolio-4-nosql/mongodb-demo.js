// Execute in mongosh against a disposable database: use mit8103_academic_nosql
use('mit8103_academic_nosql');
db.student_profiles.insertMany([
  {matric_number:'STU00003',name:{first:'Student3',last:'Demo'},program:'MIT',skills:['SQL','Python'],preferences:{notifications:true,theme:'dark'}},
  {matric_number:'STU00006',name:{first:'Student6',last:'Demo'},program:'MIT',skills:['MongoDB','JavaScript'],preferences:{notifications:false,theme:'light'}}
]);

// Create a unique index on matric_number to ensure no duplicates
db.student_profiles.createIndex({ matric_number: 1 }, { unique: true });

// Find all students in the Computer Science program
db.student_profiles.find({ program: 'Computer Science' });

// Find all students with the skill 'Python'
db.student_profiles.find({ 'skills': 'Python' });

//Find students who prefer dark mode
db.student_profiles.find({ 'preferences.theme': 'dark' });

// Update a document David Bello's notification preference from false to true
db.student_profiles.updateOne({ matric_number: "STU002" },{$set: {"preferences.notifications_enabled": true,},});

// Run an aggregation pipeline
db.student_profiles.aggregate([
  {
    $group: {
      _id: "$program",
      total_students: { $sum: 1 },
    },
  },
  {
    $sort: {
      total_students: -1,
    },
  },
]);