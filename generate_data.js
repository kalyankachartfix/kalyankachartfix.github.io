const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, 'src', 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}

const markets = [
  { id: 'kalyan-jodi-chart', name: 'Kalyan Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'] },
  { id: 'kalyan-night-jodi-chart', name: 'Kalyan Night Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'] },
  { id: 'main-bazar-jodi-chart', name: 'Main Bazar Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri'] },
  { id: 'madhur-night-jodi-chart', name: 'Madhur Night Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'] },
  { id: 'milan-day-jodi-chart', name: 'Milan Day Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'] },
  { id: 'milan-night-jodi-chart', name: 'Milan Night Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'] },
  { id: 'rajdhani-day-jodi-chart', name: 'Rajdhani Day Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri'] },
  { id: 'rajdhani-night-jodi-chart', name: 'Rajdhani Night Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri'] },
  { id: 'time-bazar-jodi-chart', name: 'Time Bazar Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'] },
  { id: 'sridevi-jodi-chart', name: 'Sridevi Jodi Chart', days: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'] }
];

// Helper to generate a random 2-digit number or "--" for closed days
function generateJodi(isActive) {
  if (!isActive) return 'XX';
  // 10% chance of being closed/holiday
  if (Math.random() < 0.05) return 'XX';
  
  // Satta Matka Jodi is 00-99
  const num = Math.floor(Math.random() * 100);
  return num.toString().padStart(2, '0');
}

// Generate weeks from Jan 6, 2025 to Jun 15, 2026 (75 weeks)
function getWeeksList() {
  const weeks = [];
  let current = new Date('2025-01-06'); // A Monday
  const end = new Date('2026-06-17'); // Current date
  
  while (current <= end) {
    // Format date as DD-MM-YYYY
    const d = current.getDate().toString().padStart(2, '0');
    const m = (current.getMonth() + 1).toString().padStart(2, '0');
    const y = current.getFullYear();
    weeks.push(`${d}-${m}-${y}`);
    
    // Move to next Monday
    current.setDate(current.getDate() + 7);
  }
  return weeks;
}

const weeks = getWeeksList();

markets.forEach(market => {
  const filePath = path.join(dataDir, `${market.id.replace('-chart', '')}.json`);
  const chartData = [];
  
  weeks.forEach(weekStart => {
    const record = {
      weekStart: weekStart
    };
    
    // Add mon, tue, wed, thu, fri, sat, sun
    ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].forEach(day => {
      const isMarketOpen = market.days.includes(day);
      record[day] = generateJodi(isMarketOpen);
    });
    
    chartData.push(record);
  });
  
  fs.writeFileSync(filePath, JSON.stringify(chartData, null, 2));
  console.log(`Generated ${filePath} with ${chartData.length} records.`);
});

console.log('All market JSON data generated successfully!');
