const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {VertexAI} = require('@google-cloud/vertexai');

admin.initializeApp();

exports.suggestPhrases = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Must be authenticated.');
  }
  const { childId, context: reqContext } = data;
  const uid = context.auth.uid;

  // Placeholder: Check consents
  const consentsSnap = await admin.firestore().doc(`users/${uid}`).get();
  const consents = consentsSnap.data()?.consents;
  if (!consents?.cloud) {
    return { candidates: ['Local phrase 1', 'Local phrase 2'] };
  }

  // Vertex AI setup - Replace with your project details
  const vertex = new VertexAI({project: 'your-project-id', location: 'us-central1'});
  const model = vertex.getGenerativeModel({ model: 'gemini-1.5-flash' });

  const prompt = `Generate 5 calming phrases for a child based on: ${JSON.stringify(reqContext)}`;
  const resp = await model.generateContent([{text: prompt}]);

  const candidates = resp.response.candidates?.map(c => c.content.parts[0].text) || [];
  await admin.firestore().collection('suggestions').add({ childId, source: 'vertex', candidates, approved: false });

  return { candidates };
});

// Add other functions like generateVisual here...