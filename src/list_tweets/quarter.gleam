import gleam/option.{type Option, None, Some}

pub type Quarter {
  Q1
  Q2
  Q3
  Q4
}

pub fn from_month(month: Int) -> Option(Quarter) {
  case month {
    1 -> Some(Q1)
    2 -> Some(Q1)
    3 -> Some(Q1)
    4 -> Some(Q2)
    5 -> Some(Q2)
    6 -> Some(Q2)
    7 -> Some(Q3)
    8 -> Some(Q3)
    9 -> Some(Q3)
    10 -> Some(Q4)
    11 -> Some(Q4)
    12 -> Some(Q4)
    _ -> None
  }
}

pub fn to_string(quarter: Quarter) -> String {
  case quarter {
    Q1 -> "q1"
    Q2 -> "q2"
    Q3 -> "q3"
    Q4 -> "q4"
  }
}
