import React from 'react';
import { withAuthenticator, Button, Heading, Divider, Flex, } from '@aws-amplify/ui-react';
import EC2InstanciesTable from './components/EC2InstanciesTable';

// styles
import '@aws-amplify/ui-react/styles.css';
import './App.css';
import "./styles/loading.css";
import "./styles/data-table.css";

const App = ({ signOut, user }) => {
  return (
    <div className="App">
      <Heading level={3} color="green" fontWeight="bold">EC2 Instances Dashboard</Heading>
      <Flex direction="row" alignItems="center">
        <Heading level={5}>User: {user.username} ({user.attributes.email})</Heading>
        <Button onClick={signOut}>Sign out</Button>
      </Flex>
      {/* <Flex direction="column">
      </Flex> */}
      <Divider orientation="horizontal"/>
      <EC2InstanciesTable />
      {/* <h1>Reusable sortable table with React</h1>
      <Table
        caption="Developers currently enrolled in this course. The table below is ordered (descending) by the Gender column."
        // data={EC2InstanceData}
        columns={columns}
      />
      <br /> */}
    </div>
  );
};

export default withAuthenticator(App);

// function App() {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.js</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// }

// export default App;
