package repository

import "errors"

var (
	ErrInternalServer = errors.New("internal server error")
	ErrDatabaseSetupFailed = errors.New("database setup failed")
)