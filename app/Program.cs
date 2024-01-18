
using app.Models;
using Microsoft.AspNetCore.OData;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// db
builder.Services.AddDbContext<EasyPublishingContext>
    (option => option.UseSqlServer(builder.Configuration.GetConnectionString("MyCnn")));
builder.Services.AddScoped<EasyPublishingContext>();

// Add services to the container.

builder.Services.AddControllers()
    .AddOData(option =>
    option.Select().Filter().Count().OrderBy().Expand().SetMaxTop(100));


// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials()
              .SetIsOriginAllowed(origin => true);
    });
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

app.Run();
