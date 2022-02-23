package repository

import (
	"context"

	"github.com/mymhimself/core-api/models/entities"
)

type IPostgres interface {
	InsertUser(ctx *context.Context, user *entities.User) error
	DeleteUser(ctx *context.Context, id uint64) error
	UpdateUser(ctx *context.Context, user *entities.User) error
	GetUserByID(ctx *context.Context, id uint64) (*entities.User, error)
}