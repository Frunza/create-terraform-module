module "mathFirst" {
  source  = "./modules/math"

  number1 = 8
  number2 = 3
}

module "mathSecond" {
  source  = "./modules/math"

  number1 = module.mathFirst.sum
  number2 = module.mathFirst.difference
}
