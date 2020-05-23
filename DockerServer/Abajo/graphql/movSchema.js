const graphql = require('graphql');
const mov = require('../models/mov');

const { 
    GraphQLObjectType, GraphQLString, 
    GraphQLID, GraphQLInt,GraphQLSchema, 
    GraphQLList,GraphQLNonNull 
} = graphql;

//Schema defines data on the Graph like object types(book type), relation between 
//these object types and describes how it can reach into the graph to interact with 
//the data to retrieve or mutate the data   

const movType = new GraphQLObjectType({
    name: 'mov',
    //We are wrapping fields in the function as we dont want to execute this ultil 
    //everything is inilized. For example below code will throw error AuthorType not 
    //found if not wrapped in a function
    fields: () => ({
        _id: { type: GraphQLID  },
        mov: { type: GraphQLString }, 
        RegisterDate: { type: GraphQLString },
        Duration: { type: GraphQLString },
        place: { type: GraphQLString }

    })
});
//RootQuery describe how users can use the graph and grab data.
//E.g Root query to get all authors, get all books, get a particular 
//book or get a particular author.
const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        mov: {
            type: movType,
            //argument passed by the user while making the query
            args: { _id: { type: GraphQLID } },
            resolve(parent, args) {
                //Here we define how to get data from database source

                //this will return the book with id passed in argument 
                //by the user
                return mov.findById(args._id);
            }
        },
        movs:{
            type: new GraphQLList(movType),
            resolve(parent, args) {
                return mov.find({});
            }
        }
    }
});

//Very similar to RootQuery helps user to add/update to the database.
const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        addMov: {
            type: movType,
            args: {
                //GraphQLNonNull make these field required
                _id: { type: new GraphQLNonNull(GraphQLString) },
                mov: { type: new GraphQLNonNull(GraphQLString) },
                RegisterDate: { type: new GraphQLNonNull(GraphQLString) },
                Duration: { type: new GraphQLNonNull(GraphQLString) },
                place: { type: new GraphQLNonNull(GraphQLString) }
            },
            resolve(parent, args) {
                let movs = new mov({
                    _id: args._id,
                    mov: args.mov,
                    RegisterDate: args.RegisterDate,
                    Duration: args.Duration,
                    place: args.place
                });
                return movs.save();
            }
        }
    }
});

//Creating a new GraphQL Schema, with options query which defines query 
//we will allow users to use when they are making request.
module.exports = new GraphQLSchema({
    query: RootQuery,
    mutation:Mutation
});
