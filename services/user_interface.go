package services

import "github.com/mymhimself/core-api/models/entities"

type IUser interface {
	CreateUser(user *entities.User)
}