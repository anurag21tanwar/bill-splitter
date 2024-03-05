inputs = [
  {
    'A' => 100,
    'B' => 50,
    'C' => 0
  },
   {
     'A' => 180,
     'B' => 0,
     'C' => 0
   }
]

def bill_splitter(transactions = {})
  return 'No Transactions Found' if transactions.keys.empty?

  median_amount = calculate_median(transactions.values)
  ledger = calculate_ledger(transactions, median_amount)
  splitted_amount(transactions, ledger)
end

def calculate_median(amounts = [])
  return 0 if amounts.empty?

  amounts.sum.to_f/amounts.size
end

def calculate_ledger(transactions, median_amount)
  ledger = {}
  transactions.each do |person, amount|
    ledger[person] = amount - median_amount
  end
  ledger
end

def splitted_amount(transactions, ledger)
  splitted_amount = {}

  transactions.each do |person, _|
    if need_to_receive?(ledger, person)
      while ledger[person] != 0
        pp = person_need_to_pay(ledger)
        amount = pp.last.abs
        adjust_amount(splitted_amount, person, pp, amount)
        ledger[pp.first] = ledger[pp.first] + amount
        ledger[person] = ledger[person] - amount
      end
    end
  end

  splitted_amount
end

def need_to_receive?(ledger, person)
  ledger[person] > 0
end

def person_need_to_pay(ledger)
  ledger.find {|_, y| y < 0 }
end

def adjust_amount(splitted_amount, person, pp, amount)
  if splitted_amount[person].is_a? Array
    splitted_amount[person] << {"#{pp.first} Owe" => amount}
  else
    splitted_amount[person] = ["#{pp.first} Owe" => amount]
  end
end

inputs.each do |input|
  p bill_splitter(input)
end