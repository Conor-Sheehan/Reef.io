const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
var schedule = require('node-schedule');
var dateFormat = require('dateformat');

// sendWifiConnectedMessage detects when a new user's Reef has successfully connected to Wi-Fi for the
// first time and sends a notification to their device
exports.sendWifiConnectedMessage = functions.database.ref('/Users/{uid}/Reef/lastConnected/').onCreate( (snap, context) => {
	const uuid = context.params.uid;

	// Print out user's ID who is receiving the notification
	console.log('Send notification to user with UID:', uuid);
	sendPushNotification(uuid, 'Wi-Fi successfully connected!', 'Reef is now connected to your local Wi-Fi.');
});

exports.sendCyclingCompleteMessage = functions.database.ref('/Users/{uid}/Ecosystem/setup').onWrite( (change, context) => {
	const uuid = context.params.uid;

	return admin.database().ref('/Users/' + uuid + '/Ecosystem/setup').once('value').then( (snapshot) => {
		const setupDate = snapshot.val().toString();
		var parsedDate = parseDate(setupDate);
		var scheduledDate = addDays(parsedDate, 14);
		console.log("Scheduled complete date: " + scheduledDate);

		schedule.scheduleJob(scheduledDate, function() {
        	console.log('Cycling is complete');

			// Update reef's grow stage to seedling once cyling is complete
			admin.database().ref('/Users/' + uuid + '/Reef/Settings/growStage').set(2);
			// Change eecosystem setup stage to let user know they can introduce fish
			admin.database().ref('/Users/' + uuid + '/GrowTracker/currentSetupStage').set("introduceFish");
			// Store notification data in users database
			admin.database().ref('/Users/' + uuid + '/Notifications/' + formatDate(new Date())).set('cyclingComplete');

        	sendPushNotification(uuid, 'Tank Finished Cycling!', 'reef is now ready for fish.');
     	});
		return snapshot.val();
	});
});

exports.sendSeedlingCompleteMessage = functions.database.ref('/Users/{uid}/GrowTracker/AllGrows/{growNumber}/seedling').onWrite( (change, context) => {
	const uuid = context.params.uid;
	const growNum = context.params.growNumber;
	console.log("Grow number: " + growNum);

	 return admin.database().ref('/Users/' + uuid + '/GrowTracker/AllGrows/'+ growNum + '/seedling').once('value').then( (snapshot) => {
	 	const seedlingDate = snapshot.val().toString();
		var parsedDate = parseDate(seedlingDate);
		var scheduledDate = addDays(parsedDate, 14);
		console.log("Scheduled seedling complete date: " + scheduledDate);

		// Schedule push notification and update database
		schedule.scheduleJob(scheduledDate, function() {
			console.log('Seedling is complete');
			// Send user notification
			sendPushNotification(uuid, 'Seedling Stage Complete!', 'Your plant is now in vegetative stage');
			// Update reef's grow stage to veg
			admin.database().ref('/Users/' + uuid + '/Reef/Settings/growStage').set(3);
			// Update user facing current grow stage
			admin.database().ref('/Users/' + uuid + '/GrowTracker/currentGrowStage').set("vegetative");
			// Update vegetative date
			admin.database().ref('/Users/' + uuid + '/GrowTracker/AllGrows/' + growNum + '/vegetative').set(formatDate(new Date()));
			// Store notification data in users database
			admin.database().ref('/Users/' + uuid + '/Notifications/' + formatDate(new Date())).set('seedlingComplete');
		});
		return snapshot.val();
	 });
});

function formatDate(date) {
	var month = date.getMonth() + 1;
    var day = date.getDate();
    var hour =  date.getHours();
    var minutes = date.getMinutes();
    var year = date.getFullYear();

    return dateFormat(date, "yyyy-mm-dd HH:MM");

    // if (day < 10) {
    // 	return year + "-" + month + "-0" + day + " " + hour + ":" + minutes;
    // } else {
    // 	return year + "-" + month + "-" + day + " " + hour + ":" + minutes;
    // }
    
}

function parseDate(date) {
	var dateStr = date.split(' ');
	var dateParts = dateStr[0].split('-');
	var timeParts = dateStr[1].split(':');
	return new Date(dateParts[0], dateParts[1] - 1, dateParts[2], timeParts[0], timeParts[1], 0); 
}

function addDays(date, days) {
  var result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function sendPushNotification(uuid, title, body) {
	var ref = admin.database().ref('/Users/' + uuid + '/UserData/fcmToken');

	// Create push otification payload
	return ref.once('value', (snapshot) => {
 		const payload = {
      		notification: {
          		title: title,
          		body: body,
          		badge: '1'
      	}
 	};

 	// Send notification to device with given value
 	admin.messaging().sendToDevice(snapshot.val(), payload)

	}, (errorObject) => {
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
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/aquariumRGB').set('255,255,255');
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/fillingTank').set(false);
	admin.database().ref('/Users/' + uuid + '/Reef/Settings/growStage').set(0);
	admin.database().ref('/Users/' + uuid + '/GrowTracker/completedGrows').set(0);
	admin.database().ref('/Users/' + uuid + '/GrowTracker/currentStage').set(0);
	admin.database().ref('/Users/' + uuid + '/GrowTracker/tasksComplete').set(0);

});

/// Deletes all data in firebase realtime database when a user is deleted
exports.removeAllData = functions.auth.user().onDelete((user) => {
	// Retrieve User's UID from user object
	const uuid = user.uid;
	// Deletee user's entire data tree
	admin.database().ref('/Users/' + uuid).remove();
});