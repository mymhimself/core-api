package repository

import (
	"context"
	"github.com/mymhimself/core-api/models/entities"
)

type IPostgres interface {
	InsertUser(ctx *context.Context, user *entities.User)
	DeleteUser(ctx *context.Context, id uint64)
	UpdateUser(ctx *context.Context, user *entities.User)
	
}