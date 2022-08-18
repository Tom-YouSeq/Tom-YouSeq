from dash import Dash, dash_table, dcc, html
import pandas as pd
from collections import OrderedDict
from dash.dependencies import Input, Output, State


app = Dash(__name__)

df = pd.DataFrame(OrderedDict([
    ('date', [0, 0, 0, 0]),
    ('library', [0, 0, 0, 0]),
    ('pool', [0, 0, 0, 0]),
    ('pool_MBR', [0, 0, 0, 0]),
    ('protocol', ['PCR-PCR', 'PCR-F-ER-A-L-PCR', 'PCR-ER-A-L-PCR', 'PCR-A-L-PCR']),
    ('cycles_PCR1', [0, 0, 0, 0]),
    ('mastermix_PCR1', ['IDT PrimeTime GE 2X', 'NEBNext UltraII Q5', 'PCRBio HiFi 2.0', 'biotechrabbit Multiplex']),
    ('temp_PCR1', [13, 43, 50, 30]),
]))

app.layout = html.Div([
        dash_table.DataTable(
        id='adding-rows-table',
        columns=[{
            'id': 'date', 'name': 'date - YYMMDD'},
            {'id': 'library', 'name': 'library'},
            {'id': 'pool', 'name': 'pool'},
            {'id': 'pool_MBR', 'name': 'pool_MBR'},
            {'id': 'protocol', 'name': 'protocol', 'presentation': 'dropdown'},
            {'id': 'cycles_PCR1', 'name': 'cycles_PCR1'},
            {'id': 'mastermix_PCR1', 'name': 'mastermix_PCR1', 'presentation': 'dropdown'},
            {'id': 'temp_PCR1', 'name': 'temp_PCR1'},
        ],
        data=[{
            'column-{}'.format(i): (j + (i-1)*9) for i in range(1, 9)}
            for j in range(1, 97)
        ],
        editable=True,
        row_deletable=True,
        dropdown={
            'mastermix_PCR1': {
                'options': [
                    {'label': i, 'value': i}
                    for i in df['mastermix_PCR1'].unique()
                ]
            },
            'protocol': {
                 'options': [
                    {'label': i, 'value': i}
                    for i in df['protocol'].unique()
                ]
            }
        },
        export_format="csv",
    ),
    html.Button('Add Row', id='editing-rows-button', n_clicks=0),
    html.Div(id='table-dropdown-container')
])

@app.callback(
    Output('adding-rows-table', 'data'),
    Input('editing-rows-button', 'n_clicks'),
    State('adding-rows-table', 'data'),
    State('adding-rows-table', 'columns'))
def add_row(n_clicks, rows, columns):
    if n_clicks > 0:
        rows.append({c['id']: '' for c in columns})
    return rows

if __name__ == '__main__':
    app.run_server(debug=True)
