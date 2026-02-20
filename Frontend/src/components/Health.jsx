import { useState, useEffect } from 'react'
import './Health.css'

function Health() {
  const [status, setStatus] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetchHealthStatus()
  }, [])

  const fetchHealthStatus = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await fetch('http://localhost:4000/health')
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      
      const data = await response.json()
      setStatus(data)
      setLoading(false)
    } catch (err) {
      setError(err.message)
      setLoading(false)
    }
  }

  return (
    <div className="health-container">
      <div className="health-card">
        <h1>Health Check</h1>
        <div className="health-content">
          {loading && <p className="loading">Checking health status...</p>}
          
          {error && (
            <div className="error">
              <p className="error-message">Error: {error}</p>
              <button onClick={fetchHealthStatus} className="retry-btn">
                Retry
              </button>
            </div>
          )}
          
          {!loading && !error && status && (
            <div className="status-success">
              <div className="status-badge">
                <span className="status-indicator"></span>
                <span className="status-text">Status: {status.status}</span>
              </div>
              <button onClick={fetchHealthStatus} className="refresh-btn">
                Refresh
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default Health
