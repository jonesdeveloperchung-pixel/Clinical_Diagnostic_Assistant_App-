function evaluateRules(symptoms, rules, specialty = null) {
  const results = [];
  
  // Filter rules by specialty if provided
  const filteredRules = specialty 
    ? rules.rules.filter(rule => rule.specialty === specialty)
    : rules.rules;

  filteredRules.forEach(rule => {
    const matchedSymptoms = [];
    const requiredMatches = [];
    const optionalMatches = [];
    
    // Check each criterion in the rule
    rule.criteria.forEach(criterion => {
      const isMatched = symptoms.some(symptom => 
        symptom.toLowerCase().includes(criterion.symptom.toLowerCase())
      );
      
      if (isMatched) {
        matchedSymptoms.push(criterion.symptom);
        
        if (criterion.required) {
          requiredMatches.push(criterion.symptom);
        } else {
          optionalMatches.push(criterion.symptom);
        }
      }
    });
    
    // Calculate score based on matches
    const totalRequired = rule.criteria.filter(c => c.required).length;
    const totalOptional = rule.criteria.filter(c => !c.required).length;
    const requiredScore = requiredMatches.length / Math.max(totalRequired, 1);
    const optionalScore = optionalMatches.length / Math.max(totalOptional, 1);
    
    // Check if minimum threshold is met
    const meetsThreshold = requiredMatches.length >= (rule.minRequired || 0) &&
                          matchedSymptoms.length >= (rule.minTotal || 1);
    
    if (meetsThreshold) {
      const confidence = (requiredScore * 0.7) + (optionalScore * 0.3);
      
      results.push({
        diagnosis: rule.diagnosis,
        confidence: Math.round(confidence * 100),
        matchedSymptoms: matchedSymptoms,
        requiredMatched: requiredMatches.length,
        totalRequired: totalRequired,
        reasoning: `Matched ${matchedSymptoms.length} symptoms including ${requiredMatches.length}/${totalRequired} required criteria`,
        icd10: rule.icd10 || null,
        recommendations: rule.recommendations || []
      });
    }
  });
  
  // Sort by confidence score
  return results.sort((a, b) => b.confidence - a.confidence);
}

module.exports = { evaluateRules };