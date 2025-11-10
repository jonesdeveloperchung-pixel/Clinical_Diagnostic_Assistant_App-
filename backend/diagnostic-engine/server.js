const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { evaluateRules } = require('./ruleEngine');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(helmet());
app.use(cors());
app.use(express.json());

// Load diagnostic rules
const rules = require('./rules.json');

app.post('/diagnose', (req, res) => {
  try {
    const { symptoms, specialty } = req.body;
    
    if (!symptoms || !Array.isArray(symptoms)) {
      return res.status(400).json({ error: 'Symptoms array is required' });
    }

    const diagnoses = evaluateRules(symptoms, rules, specialty);
    
    res.json({
      success: true,
      diagnoses: diagnoses,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Diagnosis error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', service: 'diagnostic-engine' });
});

app.listen(PORT, () => {
  console.log(`Diagnostic Engine running on port ${PORT}`);
});