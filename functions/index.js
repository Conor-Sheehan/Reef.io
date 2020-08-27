const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
var schedule = require('node-schedule');

// sendWifiConnectedMessage detects when a new user's Reef has successfully connected to Wi-Fi for the
// first time and sends a notification to their device
exports.sendWifiConnectedMessage = functions.database.ref('/Users/{uid}/Reef/lastConnected/').onCreate( (snap, context) => {
	const uuid = context.params.uid;

	// Print out user's ID who is receiving the notification
	console.log('Send notification to user with UID:', uuid);

	// Get the reference node to retrieve the users messaging token
	var ref = admin.database().ref('/Users/' + uuid + '/UserData/fcmToken');

	// Once the token value has been read, compose the notification and send it to the user's device
	return ref.once('value', function(snapshot) {
         const payload = {
              notification: {
                  title: 'Wi-Fi successfully connected!',
                  body: 'Reef is now connected to your local Wi-Fi.'
              }
         };

         admin.messaging().sendToDevice(snapshot.val(), payload)

    }, function (errorObject) {
        console.log("The read failed: " + errorObject.code);
    });

});

exports.sendCyclingCompleteMessage = functions.database.ref('/Users/{uid}/Ecosystem/setup').onWrite( (change, context) => {
	const uuid = context.params.uid;

	return admin.database().ref('/Users/' + uuid + '/Ecosystem/setup').once('value').then( function(snapshot) {
		const setupDate = snapshot.val().toString();
		var dateStr = setupDate.split(' ');
		var dateParts = dateStr[0].split('-');
		var timeParts = dateStr[1].split(':');
		var parsedDate = new Date(dateParts[0], dateParts[1] - 1, dateParts[2], timeParts[0], timeParts[1], 0); 
		var scheduledDate = addDays(parsedDate, 14);
		console.log("Scheduled complete date: " + scheduledDate);

		var j = schedule.scheduleJob(scheduledDate, function(){
        	console.log('Cycling is complete');

			admin.database().ref('/Users/' + uuid + '/Ecosystem/cyclingComplete').set(true);

        	sendPushNotification(uuid, 'Tank Finished Cycling!', 'reef is now ready for fish.')

     	});
		return snapshot.val();
	});

});

function addDays(date, days) {
  var result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function sendPushNotification(uuid, title, body) {
	var ref = admin.database().ref('/Users/' + uuid + '/UserData/fcmToken');

	// Create push otification payload
	return ref.once('value', function(snapshot) {
 		const payload = {
      		notification: {
          		title: title,
          		body: body
      	}
 	};

 	// Send notification to device with given value
 	admin.messaging().sendToDevice(snapshot.val(), payload)

	}, function (errorObject) {
		console.log("The read failed: " + errorObject.code);
	});
}
	


// initializeDatabase stores the initial values for a user's Reef Ecosystem once the user
// is Authorized by Firebase
exports.initializeDatabase = functions.auth.user().onCreate((user) => {
	// Retrieve User's UID from user object
	const uuid = user.uid;

	// Initialize sunrise branch in user's database
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/sunrise').set('7:00');
	// Initialize aquariumRGB branch in user's database
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/aquariumRGB').set('255,255,255');
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/fillingTank').set(false);
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/growStage').set(0);
	admin.database().ref('/Users/' + uuid + '/GrowTracker/completedGrows').set(0);
	admin.database().ref('/Users/' + uuid + '/GrowTracker/currentStep').set(0);
	admin.database().ref('/Users/' + uuid + '/GrowTracker/tasksComplete').set(0);


});

/// Deletes all data in firebase realtime database when a user is deleted
exports.removeAllData = functions.auth.user().onDelete((user) => {
	// Retrieve User's UID from user object
	const uuid = user.uid;
	// Deletee user's entire data tree
	admin.database().ref('/Users/' + uuid).remove();
});