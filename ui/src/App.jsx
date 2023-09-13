import React, { useState, useEffect } from 'react'
import {FaTimes} from 'react-icons/fa'
import './App.css'

function App() {
  const [time, setTime] = useState('')
  const [garage, setGarage] = useState('Midtby Garage')
  const [status, setStatus] = useState(false)
  const [vehicles, SetVehicles] = useState([])

  useEffect(() => {
    const updateTime = () => {
      const currentTime = new Date();
      const hours = currentTime.getHours().toString().padStart(2, '0');
      const minutes = currentTime.getMinutes().toString().padStart(2, '0');
      const formattedTime = `${hours}:${minutes}`;
      setTime(formattedTime)
    };

    const intervalId = setInterval(updateTime, 1000);

    return () => clearInterval(intervalId)

  }, [])

  window.addEventListener('message', function (event) {
    var item = event.data;

    if (item.opengarage === true) {
      setStatus(true);
      SetVehicles(JSON.parse(item.vehicles))
      setGarage(item.garage)
    }
  });

  const close = () => {
    fetchData('garage', {
      action: "close",
    })
    setStatus(false)
  }

  const spawncar = (car, plate) => {
    console.log(car,plate)
    fetchData('garage', {
      action: "spawncar",
      model: car,
      plate: plate,
    })
    setStatus(false)
  }

  return (
    <>
    {status && (
      <div className="tabletholder">
        <div className="tablet">
          <div className="top">
            <p id="clock">{time}</p>
            <p className='garage-name'>{garage}</p>
            <button onClick={() => close()} className='cross'>
              <FaTimes size="24px" color='white'/>
            </button>
            <div className='backdrop'></div>
          </div>
          <div className='main'>
            <div className='cars'>
              {vehicles
              .map((vehicle, index) => (
                  <>
                  <div className='car' key={index}>
                    <div className='titel'>{vehicle.label}</div>
                    <div className='type'>
                      <p className='type-name'>Nummerplade:</p>
                      <p>{vehicle.plate}</p>
                    </div>
                    <div className='type'>
                      <p className='type-name'>Status:</p>
                      <p>{JSON.parse(vehicle.props).engineHealth/10}%</p>
                    </div>
                    <div className='type'>
                      <p className='type-name'>Brændstof:</p>
                      <p>{JSON.parse(vehicle.props).fuelLevel}%</p>
                    </div>
                    <div className='spawn-button'>
                      <button onClick={() => spawncar(vehicle.model, vehicle.plate)}className='button'>Spawn {vehicle.label}</button>
                    </div>
                  </div>
                  </>
                ))
              }
          </div>
        </div>
      </div>
      </div>
      )}
    </>
  )
}

const fetchData = (action, data) => {
  if (!action || !data) return;
  
  fetch(`https://${GetParentResourceName()}/${action}`, { // eslint-disable-line
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(data)
}).then(resp => resp.json()).then(resp => console.log(resp));
};


export default App
