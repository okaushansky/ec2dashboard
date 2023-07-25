import React, { useEffect, useState } from "react";
import Datatable from "./DataTable";
import Loading from "./Loading";
import { API, graphqlOperation } from "aws-amplify";
import { getEC2Instances } from '../graphql/queries';
import { Button } from '@aws-amplify/ui-react';

const columns = [
  { Header: 'ID', accessor: 'id' },
  { Header: 'Name', accessor: 'name' },
  { Header: 'Type', accessor: 'type' },
  { Header: 'State', accessor: 'state' },
  { Header: 'Availability Zone', accessor: 'az' },
  { Header: 'Public IP', accessor: 'publicIP' },
  { Header: 'Private IP', accessor: 'privateIP' },
];

const initialState = {
  pageSize: 10,
  pageIndex: 0
};

const EC2InstancesTable = () => {
  const [tableData, setTableData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchTableData();
  }, []);

  const fetchTableData = async () => {
    console.log('Start fetchEC2Instances');
    try {
      setLoading(true);
      const { data } = await API.graphql(graphqlOperation(getEC2Instances));
      console.log('fetchEC2Instances: ', data.getEC2Instances);
      setTableData(data.getEC2Instances.items);
    } catch (error) {
      console.log(error);
      console.error('Error fetching EC2 instances:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRefreshTable = () => {
    fetchTableData();
  };

  const renderTable = () => {
    if (loading) {
      return <Loading />;
    } else {
      return (
        <>
          <Button onClick={handleRefreshTable}>Refresh Table</Button>
          <Datatable data={tableData} columns={columns} initialState={initialState} />
        </>
      );
    }
  };

  return <>{renderTable()}</>;
};

export default EC2InstancesTable;