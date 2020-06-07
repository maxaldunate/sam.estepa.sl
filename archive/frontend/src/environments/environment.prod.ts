export const environment = {
    production: true,
    mysfitsApiUrl: 'https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod/api',
    mysfitsStreamingServiceUrl: 'https://pya3zcp8a2.execute-api.eu-west-1.amazonaws.com/prod',
    mysfitsQuestionServiceUrl: 'https://pya3zcp8a2.execute-api.eu-west-1.amazonaws.com/prod',
    categories:[
      {
        title: "Good/Evil",
        filter: "GoodEvil",
        selections:[
          "Good",
          "Neutral",
          "Evil"
        ]
      },
      {
        title: "Lawful/Chaotic",
        filter: "LawChaos",
        selections:[
          "Lawful",
          "Neutral",
          "Chaotic"
        ]
      }
    ] 
  };