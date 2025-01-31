# Eventopia - Smart Event Management System
Eventopia is a modern event management application designed to streamline event discovery, booking, and ticket management. Built with Flutter for cross-platform compatibility, it integrates Firebase for authentication, Firestore as the database, and Firebase Storage for media handling. The app provides users with a seamless way to browse and book events while supporting both free and paid ticketing via Stripe Payment Gateway.

Users can browse events by category, filter based on preferences, and mark favorite events. The booking system ensures smooth event reservations, and successful transactions trigger automated email confirmations via Firebase Functions and Nodemailer. Event data is dynamically fetched from Firestore, ensuring real-time updates.

Additionally, users can manage their bookings through the "My Bookings" section and revisit their favorite events. The app also includes a Help & Support section with FAQs and contact options for assistance.

For security, sensitive credentials (e.g., API keys, database URLs) are stored securely using environment variables (.env), and GitHub history is sanitized to prevent accidental exposure.

This project showcases expertise in Flutter, Firebase, Stripe, and modern state management techniques, making it a scalable and efficient event management solution.
