const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
const dotenv = require("dotenv");

// ✅ Load environment variables
dotenv.config();

// ✅ Initialize Firebase Admin SDK
admin.initializeApp();

// ✅ Nodemailer configuration
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER, // Securely fetch Gmail ID from .env
    pass: process.env.EMAIL_PASS, // Securely fetch App Password from .env
  },
});

// ✅ Stripe Payment Intent Function
exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    const { amount, currency } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount, // Amount in cents (e.g., $10.00 is 1000)
      currency, // e.g., 'usd'
    });

    res.status(200).send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.error("Error creating payment intent:", error.message);
    res.status(400).send({ error: error.message });
  }
});

// ✅ Send Booking Confirmation Email Function
exports.sendBookingConfirmation = functions.firestore
  .document("users/{userId}/bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const bookingData = snapshot.data();
    const { title, date, location } = bookingData; // Extract event details
    const userId = context.params.userId;

    try {
      // ✅ Get user email from Firebase Authentication
      const userRecord = await admin.auth().getUser(userId);
      const userEmail = userRecord.email;

      if (!userEmail) {
        console.log(`No email found for user ID: ${userId}`);
        return null;
      }

      // ✅ Email content
      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: userEmail,
        subject: `Booking Confirmation: ${title}`,
        html: `
          <h2>Booking Confirmation</h2>
          <p>Thank you for booking <strong>${title}</strong>.</p>
          <p><strong>Date:</strong> ${date}</p>
          <p><strong>Location:</strong> ${location}</p>
          <p>Enjoy the event!</p>
        `,
      };

      // ✅ Send the email
      await transporter.sendMail(mailOptions);
      console.log(`Booking confirmation email sent successfully to: ${userEmail}`);
    } catch (error) {
      console.error("Error sending booking confirmation email:", error.message);
    }
  });
