/* eslint-disable no-unused-vars */
// import logo from './logo.svg';
import React, { useEffect, useState } from 'react';
import './App.css'
import 'bootstrap/dist/css/bootstrap.min.css'

function App() {
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    setLoading(false);
 
  }, []);

  return loading ? (
    <div className="App">
      {' '}
      <div className="container justify-content-middle">
        <i className="fa-solid fa-sync fa-spin"></i>
      </div>
    </div>
  ) : (
    <div className="App">
      DDKits CLI
    </div>
  );
}

export default App;
