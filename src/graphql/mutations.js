/* eslint-disable */
// this is an auto generated file. This will be overwritten

export const createEC2Instance = /* GraphQL */ `
  mutation CreateEC2Instance(
    $input: CreateEC2InstanceInput!
    $condition: ModelEC2InstanceConditionInput
  ) {
    createEC2Instance(input: $input, condition: $condition) {
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
export const updateEC2Instance = /* GraphQL */ `
  mutation UpdateEC2Instance(
    $input: UpdateEC2InstanceInput!
    $condition: ModelEC2InstanceConditionInput
  ) {
    updateEC2Instance(input: $input, condition: $condition) {
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
export const deleteEC2Instance = /* GraphQL */ `
  mutation DeleteEC2Instance(
    $input: DeleteEC2InstanceInput!
    $condition: ModelEC2InstanceConditionInput
  ) {
    deleteEC2Instance(input: $input, condition: $condition) {
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
