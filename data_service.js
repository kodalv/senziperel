async function fetchData() {
  console.log('Fetching data...');
  await new Promise(r => setTimeout(r, 2000));
  console.log('Data loaded');
}
fetchData();
