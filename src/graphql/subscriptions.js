/* eslint-disable */
// this is an auto generated file. This will be overwritten

export const onCreateEC2Instance = /* GraphQL */ `
  subscription OnCreateEC2Instance(
    $filter: ModelSubscriptionEC2InstanceFilterInput
  ) {
    onCreateEC2Instance(filter: $filter) {
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
export const onUpdateEC2Instance = /* GraphQL */ `
  subscription OnUpdateEC2Instance(
    $filter: ModelSubscriptionEC2InstanceFilterInput
  ) {
    onUpdateEC2Instance(filter: $filter) {
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
export const onDeleteEC2Instance = /* GraphQL */ `
  subscription OnDeleteEC2Instance(
    $filter: ModelSubscriptionEC2InstanceFilterInput
  ) {
    onDeleteEC2Instance(filter: $filter) {
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
