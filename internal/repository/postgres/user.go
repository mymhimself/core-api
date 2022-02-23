package postgres

import (
	"context"

	"github.com/mymhimself/core-api/models/entities"
)

func (p *postgres) InsertUser(ctx *context.Context, user *entities.User) error {
	panic("not implemented")
}

func (p *postgres) DeleteUser(ctx *context.Context, id uint64) error {
	panic("not implemented")
}

func (p *postgres) UpdateUser(ctx *context.Context, user *entities.User) error {
	panic("not implemented")
}