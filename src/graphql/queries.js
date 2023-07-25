/* eslint-disable */
// this is an auto generated file. This will be overwritten

export const getEC2Instances = /* GraphQL */ `
  query GetEC2Instances(
    $page: Int
    $perPage: Int
    $sortField: String
    $sortDirection: String
  ) {
    getEC2Instances(
      page: $page
      perPage: $perPage
      sortField: $sortField
      sortDirection: $sortDirection
    ) {
      items {
        id
        name
        description
        type
        state
        az
        publicIP
        privateIP
        createdAt
        updatedAt
        __typename
      }
      total
      __typename
    }
  }
`;
export const getEC2Instance = /* GraphQL */ `
  query GetEC2Instance($id: ID!) {
    getEC2Instance(id: $id) {
      id
      name
      description
      type
      state
      az
      publicIP
      privateIP
      createdAt
      updatedAt
      __typename
    }
  }
`;
export const listEC2Instances = /* GraphQL */ `
  query ListEC2Instances(
    $filter: ModelEC2InstanceFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listEC2Instances(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        name
        description
        type
        state
        az
        publicIP
        privateIP
        createdAt
        updatedAt
        __typename
      }
      nextToken
      __typename
    }
  }
`;
