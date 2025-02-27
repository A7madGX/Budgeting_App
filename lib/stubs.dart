final chartJson = {
  "type": "chart",
  "data": {
    "chartType": "line",
    "labels": ["label1", "label2", "label3"],
    "series": [
      {
        "name": "series1",
        "data": [1, 2, 3],
      },
      {
        "name": "series2",
        "data": [4, 5, 6],
      },
    ],
  },
};

final expenseOperationJson = {
  "type": "expenseOperation",
  "data": [
    {
      "id": 1,
      "amount": 100.0,
      "category": "Food",
      "description": "Lunch",
      "date": "2022-01-01",
      "operationType": "add",
    },
    {
      "id": 2,
      "amount": 200.0,
      "category": "Transport",
      "description": "Bus",
      "date": "2022-01-02",
      "operationType": "add",
    },
  ],
};
