package enums

type AccountStatus int


var mapAccountStatus map[int]string 

const (
	AccountStatusInvalid  = iota
	AccountStatusActive
	AccountStatusDeActive
)


func (s *AccountStatus) String() string {
	return mapAccountStatus[int(*s)]
}

