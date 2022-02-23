package enums

type AccountStatus int


var mapAccountStatus map[int]string 

const (
	AccountStatusInvalid AccountStatus = iota
	AccountStatusActive AccountStatus
	AccountStatusDeActive AccountStatus
)


func (s *AccountStatus) String() string {
	return mapAccountStatus[int(*s)]
}

