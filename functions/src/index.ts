import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from 'firebase-admin';

admin.initializeApp();

// Run every day at midnight (00:00)
export const processEndOfDayPoints = onSchedule("0 0 * * *", async (event) => {
  try {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const startOfYesterday = new Date(yesterday.getFullYear(), yesterday.getMonth(), yesterday.getDate());
    const endOfYesterday = new Date(yesterday.getFullYear(), yesterday.getMonth(), yesterday.getDate() + 1);
    
    // Get all users
    const usersSnapshot = await admin.firestore().collection('users').get();
    
    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      const userEmail = userDoc.id;
      const targetCalories = userData.dailyCalories || 2000;

      // Check if points were already processed for this user yesterday
      const pointsHistoryRef = userDoc.ref
        .collection('pointsHistory')
        .doc(startOfYesterday.toISOString().split('T')[0]);
      
      const pointsHistoryDoc = await pointsHistoryRef.get();
      if (pointsHistoryDoc.exists) {
        console.log(`Points already processed for user ${userEmail} on ${startOfYesterday.toISOString().split('T')[0]}`);
        continue;
      }

      // Get user's meals for yesterday
      const mealsSnapshot = await admin.firestore()
        .collection('meals')
        .where('userEmail', '==', userEmail)
        .where('date', '>=', startOfYesterday)
        .where('date', '<', endOfYesterday)
        .get();

      // Calculate total calories
      let totalCalories = 0;
      mealsSnapshot.docs.forEach(mealDoc => {
        totalCalories += mealDoc.data().calories || 0;
      });

      // Calculate points deduction
      const points = calculateCaloriePoints(targetCalories, totalCalories);
      
      // Update user's points (process both positive and negative points)
      await admin.firestore().runTransaction(async (transaction) => {
        const userDocRef = admin.firestore().collection('users').doc(userEmail);
        const userSnapshot = await transaction.get(userDocRef);
        if (!userSnapshot.exists) return;
        
        const currentPoints = userSnapshot.data()?.points || 0;
        const newPoints = currentPoints + points;
        
        transaction.update(userDocRef, { points: newPoints });
      });

      // Record the points processing
      await pointsHistoryRef.set({
        processed: true,
        pointsChange: points,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        totalCalories: totalCalories,
        targetCalories: targetCalories
      });

      console.log(`Processed points for user ${userEmail}: ${points} points change`);
    }
    
    console.log('Successfully processed end of day points for all users');
  } catch (error) {
    console.error('Error processing end of day points:', error);
    throw error;
  }
});

function calculateCaloriePoints(targetCalories: number, actualCalories: number): number {
  // Calculate the percentage difference from target
  const percentDiff = Math.abs(actualCalories - targetCalories) / targetCalories * 100;
  
  // If within 5% of target, award full points
  if (percentDiff <= 5) {
    return 50; // POINTS_CALORIES_PERFECT
  }
  
  // Calculate points deduction based on deviation
  // Deduct 10 points for every 5% deviation after the initial 5% grace
  const deduction = Math.ceil((percentDiff - 5) / 5) * 10;
  
  // Cap the maximum deduction at -100 points
  return -Math.min(deduction, 100);
} 