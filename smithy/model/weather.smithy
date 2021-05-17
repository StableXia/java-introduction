namespace example.weather

/// Provides weather forecasts.
@paginated(inputToken: "nextToken", outputToken: "nextToken", pageSize: "pageSize")
service Weather {
    version: "2021.05.17",
    resources: [City],
    operations: [GetCurrentTime]
}

@readonly
operation GetCurrentTime {
    output: GetCurrentTimeOutput
}

structure GetCurrentTimeOutput {
    @required
    time: Timestamp
}

@paginated(items: "items")
@readonly
operation ListCities {
    input: ListCitiesInput,
    output: ListCitiesOutput
}

structure ListCitiesInput {
    nextToken: String,
    pageSize: Integer
}

structure ListCitiesOutput {
    nextToken: String,

    @required
    items: CitySummaries,
}

// CitySummaries is a list of CitySummary structures.
list CitySummaries {
    member: CitySummary
}

// CitySummary contains a reference to a City.
@references([{resource: City}])
structure CitySummary {
    @required
    cityId: CityId,

    @required
    name: String,
}

resource City {
    identifiers: {
        cityId: CityId
    },
    read: GetCity,
    list: ListCities.
    resources: [Forecast],
}

resource Forecast {
    identifiers: { cityId: CityId },
    read: GetForecast,
}

@readonly
operation GetCity {
    input: GetCityInput,
    output: GetCityOutput,
    errors: [NoSuchResource]
}

structure GetCityInput {
    // "cityId" provides the identifier for the resource and has to be marked as required.
    @required
    cityId: CityId
}

structure GetCityOutput {
    // "required" is used on output to indicate if the service will always provide a value for the member.
    @required
    name: String,

    @required
    coordinates: CityCoordinates,
}

structure CityCoordinates {
    @required
    latitude: Float,

    @required
    longitude: Float,
}

// "error" is a trait that is used to specialize a structure as an error.
@error("client")
structure NoSuchResource {
    @required
    resourceType: String
}

@readonly
operation GetForecast {
    input: GetForecastInput,
    output: GetForecastOutput
}

// "cityId" provides the only identifier for the resource since a Forecast doesn't have its own.
structure GetForecastInput {
    @required
    cityId: CityId,
}

structure GetForecastOutput {
    chanceOfRain: Float
}

@pattern("^[A-Za-z0-9 ]+$")
string CityId