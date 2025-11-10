const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const http = require('http');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Simple proxy function
function proxyRequest(targetPort, pathPrefix) {
  return (req, res) => {
    const targetPath = req.path.replace(pathPrefix, '');
    const options = {
      hostname: 'localhost',
      port: targetPort,
      path: targetPath,
      method: req.method,
      headers: req.headers
    };

    const proxyReq = http.request(options, (proxyRes) => {
      res.status(proxyRes.statusCode);
      Object.keys(proxyRes.headers).forEach(key => {
        res.setHeader(key, proxyRes.headers[key]);
      });
      proxyRes.pipe(res);
    });

    proxyReq.on('error', (err) => {
      console.error('Proxy error:', err);
      res.status(500).json({ error: 'Service unavailable' });
    });

    if (req.body) {
      proxyReq.write(JSON.stringify(req.body));
    }
    proxyReq.end();
  };
}

// Routes
app.use('/api/diagnosis', proxyRequest(3001, '/api/diagnosis'));
app.use('/api/users', proxyRequest(3002, '/api/users'));
app.use('/api/reports', proxyRequest(3003, '/api/reports'));

app.listen(PORT, () => {
  console.log(`API Gateway running on port ${PORT}`);
});