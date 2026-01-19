Rahaagir: Map Navigation & Travel Planner

Rahaagir is a comprehensive, cross-platform mobile application designed to simplify travel planning and navigation. Built with Flutter and Firebase, the app offers real-time location discovery, budget-aware filtering, and optimized route planning for travelers.




🚀 Key Features

Real-time Navigation: Integrated Google Maps API to provide seamless navigation and interactive pin-points for attractions.






Intelligent Itinerary Planner: Users can search for and save attractions, hotels (including dharamshalas), and restaurants to a persistent itinerary.






Budget-Based Discovery: Advanced filtering options that tailor searches based on travel modes (Auto, Taxi) and budget constraints.





Secure Authentication: Robust user login and registration systems powered by Firebase Authentication.



Global Search: Dynamic location selection utilizing a hierarchical Country-State-City structure.


🛠️ Tech Stack

Frontend: Flutter (Dart) using a declarative UI approach.



State Management: Provider for efficient, reactive data handling across the application.



Backend: Firebase (Cloud Firestore) for real-time NoSQL data synchronization.



APIs: Google Maps SDK, Google Places API (for nearby search), and Directions API (for route calculation).



🏗️ Architecture & Logic
The application utilizes a Widget Tree architecture, ensuring UI consistency across Android and iOS. Key backend logic includes:



Fare Calculation: Custom Dart functions that estimate transport costs based on real-time distance data and selected transport modes.



Authentication Flow: Secure session management via firebase_auth with integrated error handling for a smooth user experience.



Data Persistence: Structured Cloud Firestore collections to manage dynamic user itineraries and attraction metadata.

🧪 Testing & Quality Assurance
The project underwent rigorous evaluation to ensure operational viability:



Functional Testing: Verified core loops such as destination searching and adding items to itineraries.




Integration Testing: Ensured seamless communication between the Google Maps API and the Flutter UI.




System Testing: Validated end-to-end user journeys from initial login to final itinerary generation.


📈 Future Roadmap

Offline Functionality: Implementing cached data and offline map persistence for premium users.




Advanced Analytics: Integrating Firebase Analytics to better understand user interaction and attraction popularity.



<img width="1716" height="510" alt="image" src="https://github.com/user-attachments/assets/5bd0be72-c14f-4297-a9d5-19d7317b6fc2" />
<img width="1599" height="475" alt="image" src="https://github.com/user-attachments/assets/9d688aff-5cd2-4267-9f18-af34c6e07993" />

