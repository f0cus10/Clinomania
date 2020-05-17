var express = require('express')
var router = express.Router();

router.get('/', (req, res, next) => {
    const dummy = {
        jobcount: 3,
        jobs: [
        {
            id: 1,
            type: 'Plumber',
            latitude: 38.9947057,
            longitude: -106.6716015,
            compensation: 220
        },
        {
            id: 2,
            type: 'Mechanic',
            latitude: 47.1890104,
            longitude: -120.9522058,
            compensation: 140
        },
        {
            id: 3,
            type: 'Electrician',
            latitude: 61.9964045,
            longitude: -49.6649807,
            compensation: 300
        }]
    }
    res.json(dummy);
})


module.exports = router;